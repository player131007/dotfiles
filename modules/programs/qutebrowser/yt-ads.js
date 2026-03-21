// ==UserScript==
// for more updated scripts, see: https://greasyfork.org/en/scripts/by-site/youtube.com
// @name         Auto Skip YouTube Ads
// @description  Speed up and skip YouTube ads automatically
// @match        *://*.youtube.com/*
// @run-at       document-end
// ==/UserScript==

(function() {
  "use strict";

  const style = document.createElement("style");
  style.id = "noads"
  style.textContent = `
    #player-ads,
    #panels > ytd-engagement-panel-section-list-renderer[target-id="engagement-panel-ads"],
    #masthead-ad,
    .yt-mealbar-promo-renderer,
    .ytp-featured-product,
    ytd-merch-shelf-renderer,
    ytmusic-mealbar-promo-renderer,
    ytmusic-statement-banner-renderer,
    ytd-reel-video-renderer:has(.ytd-ad-slot-renderer),
    ytd-rich-item-renderer:has(.ytd-ad-slot-renderer),
    ytd-ad-slot-renderer {
      display: none !important;
    }
  `;
  document.head.appendChild(style);

  function check_and_skip_ads(player) {
    if(player.classList.contains("ad-showing")) {
      console.log("found ad");
      const ad = document.getElementsByClassName("html5-main-video")[0];

      ad.currentTime = 9999999999;
      ad.play().then(() => { ad.currentTime = 0; });

      return true;
    }

    return false;
  }

  const adObserver = new MutationObserver((mutations, observer) => {
    for(const m of mutations) if(check_and_skip_ads(m.target)) {
      observer.takeRecords();
      return;
    }
  });

  document.addEventListener("yt-navigate-finish", () => {
    const player = document.getElementById("movie_player");
    if(player) {
      check_and_skip_ads(player);
      adObserver.observe(player, { attributeFilter: [ "class" ] });
    }
  });

  document.addEventListener("yt-navigate-start", () => {
    adObserver.disconnect();
  });
})();
