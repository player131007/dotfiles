glide.autocmds.create(
    "UrlEnter",
    { hostname: "www.youtube.com" },
    ({ tab_id, url }) => {
        if (URL.parse(url)?.pathname !== "/watch") return;
        glide.content.execute(
            () => {
                const BASE = 5;
                function logarithmicVolume(value: number): number {
                    return (Math.pow(BASE, value) - 1) / (BASE - 1);
                }

                function init() {
                    const volume_slider =
                        document.getElementsByClassName("ytp-volume-panel")[0];
                    const video = document.getElementsByClassName(
                        "html5-main-video",
                    )[0] as HTMLVideoElement;
                    if (!volume_slider || !video) {
                        setTimeout(init, 500);
                        return;
                    }

                    let timer: number = 0;
                    const observer = new MutationObserver((mutations) => {
                        if (timer) clearTimeout(timer);
                        timer = setTimeout(() => {
                            mutations.forEach((mutation) => {
                                video.volume = logarithmicVolume(
                                    parseInt(
                                        (mutation.target as Element)
                                            .ariaValueNow as string,
                                    ) / 100,
                                );
                            });
                        }, 10);
                    });

                    observer.observe(volume_slider, {
                        attributeFilter: ["aria-valuenow"],
                    });
                }
                init();
            },
            { tab_id },
        );
    },
);
