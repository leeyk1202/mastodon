# frozen_string_literal: true

Rails.application.configure do
  config.i18n.available_locales = [
    :af,
    :an,
    :ar,
    :ast,
    :be,
    :bg,
    :bn,
    :br,
    :bs,
    :ca,
    :ckb,
    :co,
    :cs,
    :cy,
    :da,
    :de,
    :el,
    :en,
    :'en-GB',
    :eo,
    :es,
    :'es-AR',
    :'es-MX',
    :et,
    :eu,
    :fa,
    :fi,
    :fo,
    :fr,
    :'fr-CA',
    :fy,
    :ga,
    :gd,
    :gl,
    :he,
    :hi,
    :hr,
    :hu,
    :hy,
    :ia,
    :id,
    :ie,
    :ig,
    :io,
    :is,
    :it,
    :ja,
    :ka,
    :kab,
    :kk,
    :kn,
    :ko,
    :ku,
    :kw,
    :la,
    :lt,
    :lv,
    :mk,
    :ml,
    :mr,
    :ms,
    :my,
    :nl,
    :nn,
    :no,
    :oc,
    :pa,
    :pl,
    :'pt-BR',
    :'pt-PT',
    :ro,
    :ru,
    :sa,
    :sc,
    :sco,
    :si,
    :sk,
    :sl,
    :sq,
    :sr,
    :'sr-Latn',
    :sv,
    :szl,
    :ta,
    :te,
    :th,
    :tr,
    :tt,
    :ug,
    :uk,
    :ur,
    :vi,
    :zgh,
    :'zh-CN',
    :'zh-HK',
    :'zh-TW',
  ]

  config.i18n.default_locale = begin
    custom_default_locale = ENV['DEFAULT_LOCALE']&.to_sym

    if Rails.configuration.i18n.available_locales.include?(custom_default_locale)
      custom_default_locale
    else
      :en
    end
  end

  config.x.posting_languages = ENV['POSTING_LANGUAGES']&.split(',')&.map(&:to_sym)
end

Rails.application.config.after_initialize do
  invalid = Rails.application.config.x.posting_languages&.difference(LanguagesHelper::SUPPORTED_LOCALES.keys)
  raise "POSTING_LANGUAGES contains invalid code: #{invalid.join(', ')}" if invalid&.any?
end
