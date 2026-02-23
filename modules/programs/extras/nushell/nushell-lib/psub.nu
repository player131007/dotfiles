def tmp_pipe [] {
  let pipe = (mktemp -t -d | path join "pipe")
  mkfifo $pipe
  $pipe
}

def cleanup_job [
  pipe: path
  task_span: record
  timeout?: duration
] {
  job spawn -t psub_cleanup {
    let id = job recv
    try {
      if $timeout != null {
        job recv --timeout $timeout
      } else {
        job recv
      }
    } catch {|err|
      job kill $id
      error make {
        msg: "psub task timed out"
        labels: [
          { span: $task_span }
        ]
      }
    }

    rm -rf ($pipe | path dirname)
  }
}

def main_job [
  pipe: path
  read: bool
  task: closure
  cleanup_job: int
] {
  job spawn -t psub {
    job id | job send $cleanup_job

    if $read {
      open --raw $pipe | do $task
    } else {
      try {
        do $task | save --append $pipe
      } catch {|err|
        if ($err.json | from json | get code) != "nu::shell::io::broken_pipe" {
          job send $cleanup_job
          error make $err
        }
      }
    }

    job send $cleanup_job
  }
}

# Execute a background task, returning a FIFO containing the output of said task.
#
# If `--read` is passed, the task will read from the pipe instead of writing to it.
@example "Opening a process substituted file" { open --raw (psub { "hello!" }) } --result "hello!"
export def main [
  task: closure # The task to run
  --read(-r) # Have the task read from the pipe
  --timeout(-t): duration # Abort the spawned task after a given amount of time
]: nothing -> path {
  let span = (metadata $task).span
  do {|pipe|
    main_job $pipe $read $task (cleanup_job $pipe $span $timeout)
    $pipe
  } (tmp_pipe)
}
