module GoogleIAP
    module ApplicationIAPAuthPatch
  
        # Returns the current user or nil if no user is logged in
        # and starts a session if needed
        def find_current_user
            user = nil

            if (emailaddress = request.headers["X-Goog-Authenticated-User-Email"].to_s.presence)
                emailaddress.sub! 'accounts.google.com:', ''

                su = User.find_by_mail(emailaddress)
                if su && su.active?
                    logger.info("  IAP Login for : #{emailaddress} (id=#{su.id})") if logger
                    user = su
                else
                    emailsplit = emailaddress.split('@')

                    user = User.new
                    user.login = emailaddress
                    user.firstname = emailsplit[0]
                    user.lastname = emailsplit[1]
                    user.mail = emailaddress
                    user.language = Setting.default_language
                    user.admin = false

                    user.register
                    user.activate

                    if user.save
                        user.reload
                        logger.info("User '#{user.login}' created from IAP login: #{emailaddress} (id=#{su.id})") if logger
                    else
                        user = nil
                        logger.error("  Failed IAP user creation for : #{emailaddress}") if logger
                        render_error :message => 'IAP Automatic User Creation Failed', :status => 403
                    end
                end
            end

            # store current ip address in user object ephemerally
            user.remote_ip = request.remote_ip if user

            user
        end
  
    end
end