# frozen_string_literal: true

class StatusLengthValidator < ActiveModel::Validator
  def validate(status)
    return unless status.local? && !status.reblog?

    @status = status
    status.errors.add(:text, I18n.t('statuses.over_character_limit', max: Setting.max_toot_chars)) if too_long?
  end

  private

  def too_long?
    countable_length > Setting.max_toot_chars.to_i
  end

  def countable_length
    total_text.mb_chars.grapheme_length
  end

  def total_text
    [@status.spoiler_text, countable_text].join
  end

  def countable_text
    return '' if @status.text.nil?

    @status.text.dup.tap do |new_text|
      new_text.gsub!(FetchLinkCardService::URL_PATTERN, 'x' * 23)
      new_text.gsub!(Account::MENTION_RE, '@\2')
    end
  end
end
