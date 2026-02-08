// ==UserScript==
// for more updated scripts, see: https://greasyfork.org/en/scripts/by-site/youtube.com
// @name         Auto Skip YouTube Ads
// @version      1.1.0
// @description  Speed up and skip YouTube ads automatically
// @author       jso8910 and others
// @match        *://*.youtube.com/*
// @run-at       document-start
// ==/UserScript==


(function() {
  'use strict'

  document.addEventListener('load', () => {
    const adShowing = document.querySelector('.ad-showing');
    if (adShowing) {
      const ad = document.querySelector('video');
      ad.play()
      ad.currentTime = 9999999999;
      setTimeout(() => { ad.currentTime = 0; }, 100)
    }
  }, true);

  document.addEventListener('readystatechange', () => {
    if (document.readyState == 'interactive') {
      const style = document.createElement('style');
      style.id = "noads"
      style.textContent =
`
#panels > ytd-engagement-panel-section-list-renderer[target-id="engagement-panel-ads"],
#masthead-ad,
.yt-mealbar-promo-renderer,
.ytp-featured-product,
ytd-merch-shelf-renderer,
ytmusic-mealbar-promo-renderer,
ytmusic-statement-banner-renderer,
ytd-reel-video-renderer:has(.ytd-ad-slot-renderer),
ytd-rich-item-renderer:has(.ytd-ad-slot-renderer),
ytd-ad-slot-renderer
{ display: none !important; }
`;
      document.head.appendChild(style);
    }
  });
})();
