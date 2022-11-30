require 'redmine'
require File.dirname(__FILE__) + '/lib/application_controller_iap_patch'

Redmine::Plugin.register :redmine_google_iap do
  name 'Google IAP Authentication'
  author 'Samuel Melrose, A1 Comms Ltd'
  description 'Performs stateless authentication when behind Google IAP'
  version '1.0'
  url 'https://github.com/a1comms/redmine-google-iap-authentication'
  author_url 'https://gitlab.com/a1comms'
  requires_redmine :version_or_higher => '4.0.0'

  settings :default => {}, :partial => 'settings/google_iap'
end

RedmineApp::Application.config.after_initialize do
    ApplicationController.prepend(GoogleIAP::ApplicationIAPAuthPatch)
end