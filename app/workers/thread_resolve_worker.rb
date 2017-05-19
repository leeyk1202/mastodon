# frozen_string_literal: true
#
# Mastodon, a GNU Social-compatible microblogging server
# Copyright (C) 2016-2017 Eugen Rochko & al (see the AUTHORS file)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

class ThreadResolveWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'pull', retry: false

  def perform(child_status_id, parent_url)
    child_status  = Status.find(child_status_id)
    parent_status = FetchRemoteStatusService.new.call(parent_url)

    return if parent_status.nil?

    child_status.thread = parent_status
    child_status.save!
  end
end
