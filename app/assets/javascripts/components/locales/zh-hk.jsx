import zh from 'react-intl/locale-data/zh';

const localeData = zh.reduce(function (acc, localeData) {
  if (localeData.locale === "zh-Hant-HK") {
    // rename the locale "zh-Hant-HK" as "zh-HK"
    // (match the code usually used in Accepted-Language header)
    acc.push(Object.assign({},
      localeData,
      {
        "locale": "zh-HK",
        "parentLocale": "zh-Hant-HK",
      }
    ));
  }
  return acc;
}, []);

export { localeData as localeData };

const zh_hk = {
  "account.block": "封鎖 @{name}",
  "account.disclaimer": "由於這個用戶在另一個服務站，實際數字會比這個更多。",
  "account.edit_profile": "修改個人資料",
  "account.follow": "關注",
  "account.followers": "關注的人",
  "account.follows_you": "關注你",
  "account.follows": "正在關注",
  "account.mention": "提及 @{name}",
  "account.mute": "將 @{name} 靜音",
  "account.posts": "文章",
  "account.report": "舉報 @{name}",
  "account.requested": "等候審批",
  "account.unblock": "解除對 @{name} 的封鎖",
  "account.unfollow": "取消關注",
  "account.unmute": "取消 @{name} 的靜音",
  "boost_modal.combo": "如你想在下次路過這顯示，請按{combo}，",
  "column_back_button.label": "返回",
  "column.blocks": "封鎖用戶",
  "column.community": "本站時間軸",
  "column.favourites": "喜歡的文章",
  "column.follow_requests": "關注請求",
  "column.home": "主頁",
  "column.notifications": "通知",
  "column.public": "跨站公共時間軸",
  "compose_form.placeholder": "你在想甚麼？",
  "compose_form.privacy_disclaimer": "你的私人文章，將被遞送至你所提及的 {domains} 用戶。你是否信任{domainsCount, plural, one {這個網站} other {這些網站}}？請留意，文章私隱設定只適用於各 Mastodon 服務站，如果 {domains} {domainsCount, plural, one {不是 Mastodon 服務站} other {之中有些不是 Mastodon 服務站}}，對方將無法收到這篇文章的私隱設定，然後可能被轉推給不能預知的用戶閱讀。",
  "compose_form.private": "標示為「只有關注你的人能看」",
  "compose_form.publish": "發文",
  "compose_form.sensitive": "將媒體檔案標示為「敏感內容」",
  "compose_form.spoiler": "將部份文字藏於警告訊息之後",
  "compose_form.unlisted": "請勿在公共時間軸顯示",
  "emoji_button.label": "加入表情符號",
  "empty_column.community": "本站時間軸暫時未有內容，快貼文來搶頭香啊！",
  "empty_column.hashtag": "這個標籤暫時未有內容。",
  "empty_column.home": "你還沒有關注任何用戶。快看看{public}，向其他用戶搭訕吧。",
  "empty_column.home.public_timeline": "公共時間軸",
  "empty_column.home": "你還沒有關注任何用戶。快看看{public}，向其他用戶搭訕吧。",
  "empty_column.notifications": "你沒有任何通知紀錄，快向其他用戶搭訕吧。",
  "empty_column.public": "跨站公共時間軸暫時沒有內容！快寫一些公共的文章，或者關注另一些服務站的用戶吧！你和本站、友站的交流，將決定這裏出現的內容。",
  "follow_request.authorize": "批准",
  "follow_request.reject": "拒絕",
  "getting_started.about_addressing": "只要你知道一位用戶的用戶名稱和域名，你可以用「@用戶名稱@域名」的格式在搜尋欄尋找該用戶。",
  "getting_started.about_shortcuts": "只要該用戶是在你現在的服務站開立，你可以直接輸入用戶𠱷搜尋。同樣的規則適用於在文章提及別的用戶。",
  "getting_started.apps": "手機或桌面應用程式",
  "getting_started.heading": "開始使用",
  "getting_started.open_source_notice": "Mastodon 是一個開放源碼的軟件。你可以在官方 GitHub ({github}) 貢獻或者回報問題。你亦可透過{apps}閱讀 Mastodon 上的消息。",
  "home.column_settings.advanced": "進階",
  "home.column_settings.basic": "基本",
  "home.column_settings.filter_regex": "使用正規表達式 (regular expression) 過濾",
  "home.column_settings.show_reblogs": "顯示被轉推的文章",
  "home.column_settings.show_replies": "顯示回應文章",
  "home.settings": "欄位設定",
  "lightbox.close": "Close",
  "loading_indicator.label": "載入中...",
  "media_gallery.toggle_visible": "打開或關上",
  "missing_indicator.label": "找不到內容",
  "navigation_bar.blocks": "被封鎖的用戶",
  "navigation_bar.community_timeline": "本站時間軸",
  "navigation_bar.edit_profile": "修改個人資料",
  "navigation_bar.favourites": "喜歡的內容",
  "navigation_bar.follow_requests": "關注請求",
  "navigation_bar.info": "關於本服務站",
  "navigation_bar.logout": "登出",
  "navigation_bar.preferences": "偏好設定",
  "navigation_bar.public_timeline": "跨站公共時間軸",
  "notification.favourite": "{name} 喜歡你的文章",
  "notification.follow": "{name} 開始關注你",
  "notification.mention": "{name} 提及你",
  "notification.reblog": "{name} 轉推你的文章",
  "notifications.clear_confirmation": "你確定要清空通知紀錄嗎？",
  "notifications.clear": "清空通知紀錄",
  "notifications.column_settings.alert": "顯示桌面通知",
  "notifications.column_settings.favourite": "喜歡你的文章:",
  "notifications.column_settings.follow": "關注你:",
  "notifications.column_settings.mention": "提及你:",
  "notifications.column_settings.reblog": "轉推你的文章:",
  "notifications.column_settings.show": "在通知欄顯示",
  "notifications.column_settings.sound": "播放音效",
  "notifications.settings": "欄位設定",
  "privacy.change": "調整私隱設定",
  "privacy.direct.long": "只有提及的用戶能看到",
  "privacy.direct.short": "私人訊息",
  "privacy.private.long": "只有關注你用戶能看到",
  "privacy.private.short": "關注者",
  "privacy.public.long": "在公共時間軸顯示",
  "privacy.public.short": "公共",
  "privacy.unlisted.long": "公開，但不在公共時間軸顯示",
  "privacy.unlisted.short": "公開",
  "reply_indicator.cancel": "取消",
  "report.heading": "舉報",
  "report.placeholder": "額外訊息",
  "report.submit": "提交",
  "report.target": "Reporting",
  "search_results.total": "{count, number} 項結果",
  "search.account": "用戶",
  "search.hashtag": "標籤",
  "search.placeholder": "搜尋",
  "search.status_by": "按{name}搜尋文章",
  "status.delete": "刪除",
  "status.favourite": "喜歡",
  "status.load_more": "載入更多",
  "status.media_hidden": "隱藏媒體內容",
  "status.mention": "提及 @{name}",
  "status.open": "展開文章",
  "status.reblog": "轉推",
  "status.reblogged_by": "{name} 轉推",
  "status.reply": "回應",
  "status.report": "舉報 @{name}",
  "status.sensitive_toggle": "點擊顯示",
  "status.sensitive_warning": "敏感內容",
  "status.show_less": "減少顯示",
  "status.show_more": "顯示更多",
  "tabs_bar.compose": "撰寫",
  "tabs_bar.federated_timeline": "跨站",
  "tabs_bar.home": "主頁",
  "tabs_bar.local_timeline": "本站",
  "tabs_bar.mentions": "提及",
  "tabs_bar.notifications": "通知",
  "tabs_bar.public": "跨站公共時間軸",
  "upload_area.title": "將檔案拖放至此上載",
  "upload_button.label": "上載媒體檔案",
  "upload_form.undo": "還原",
  "upload_progress.label": "上載中……",
  "video_player.expand": "展開影片",
  "video_player.toggle_sound": "開關音效",
  "video_player.toggle_visible": "打開或關上",
};

export default zh_hk;
