# frozen_string_literal: true

module LanguagesHelper
  HUMAN_LOCALES = {
    af: 'Afrikaans',
    ar: 'العربية',
    ast: 'Asturianu',
    bg: 'Български',
    bn: 'বাংলা',
    br: 'Breton',
    ca: 'Català',
    co: 'Corsu',
    cs: 'Čeština',
    cy: 'Cymraeg',
    da: 'Dansk',
    de: 'Deutsch',
    el: 'Ελληνικά',
    en: 'English',
    eo: 'Esperanto',
    'es-AR': 'Español (Argentina)',
    'es-MX': 'Español (México)',
    es: 'Español',
    et: 'Eesti',
    eu: 'Euskara',
    fa: 'فارسی',
    fi: 'Suomi',
    fr: 'Français',
    ga: 'Gaeilge',
    gd: 'Gàidhlig',
    gl: 'Galego',
    he: 'עברית',
    hi: 'हिन्दी',
    hr: 'Hrvatski',
    hu: 'Magyar',
    hy: 'Հայերեն',
    id: 'Bahasa Indonesia',
    io: 'Ido',
    is: 'Íslenska',
    it: 'Italiano',
    ja: '日本語',
    'ja-IM': '日本語(im@s)',
    ka: 'ქართული',
    kab: 'Taqbaylit',
    kk: 'Қазақша',
    kmr: 'Kurmancî',
    kn: 'ಕನ್ನಡ',
    ko: '한국어',
    ku: 'سۆرانی',
    lt: 'Lietuvių',
    lv: 'Latviešu',
    mk: 'Македонски',
    ml: 'മലയാളം',
    mr: 'मराठी',
    ms: 'Bahasa Melayu',
    nl: 'Nederlands',
    nn: 'Nynorsk',
    no: 'Norsk',
    oc: 'Occitan',
    pl: 'Polski',
    'pt-BR': 'Português (Brasil)',
    'pt-PT': 'Português (Portugal)',
    pt: 'Português',
    ro: 'Română',
    ru: 'Русский',
    sa: 'संस्कृतम्',
    sc: 'Sardu',
    si: 'සිංහල',
    sk: 'Slovenčina',
    sl: 'Slovenščina',
    sq: 'Shqip',
    'sr-Latn': 'Srpski (latinica)',
    sr: 'Српски',
    sv: 'Svenska',
    ta: 'தமிழ்',
    te: 'తెలుగు',
    th: 'ไทย',
    tr: 'Türkçe',
    uk: 'Українська',
    ur: 'اُردُو',
    vi: 'Tiếng Việt',
    zgh: 'ⵜⴰⵎⴰⵣⵉⵖⵜ',
    'zh-CN': '简体中文',
    'zh-HK': '繁體中文（香港）',
    'zh-TW': '繁體中文（臺灣）',
    zh: '中文',
  }.freeze

  def human_locale(locale)
    if locale == 'und'
      I18n.t('generic.none')
    else
      HUMAN_LOCALES[locale.to_sym] || locale
    end
  end
end
