// ==UserScript==
// @name         Circumvent Youtube's Stable Volume
// @description  Set the video's real volume using the volume slider's value
// @match        *://www.youtube.com/*
// @run-at       document-end
// ==/UserScript==

(function() {
  "use strict";

  const volumeObserver = new MutationObserver(mutations => {
    const video = document.getElementsByClassName("html5-main-video")[0];
    for(const m of mutations) {
      video.volume = parseInt(m.target.ariaValueNow) / 100;
    }
  });

  document.addEventListener("yt-navigate-finish", () => {
    const volume_panel = document.getElementsByClassName("ytp-volume-panel")[0];
    if(volume_panel) volumeObserver.observe(volume_panel, { attributeFilter: [ "aria-valuenow" ] });
  });
})();
