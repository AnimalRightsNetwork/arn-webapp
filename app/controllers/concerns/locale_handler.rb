module LocaleHandler
  extend ActiveSupport::Concern

  private
    # Handle locale based on accept header, domain and session information
    def handle_locale
      # Reset to default locale
      I18n.locale = I18n.default_locale

      if request.subdomain.empty?
        unless session.include? :language_set
          # Get compatible locale from "Accept-Language" header
          header_locale = http_accept_language
            .language_region_compatible_from(I18n.available_locales)&.to_sym
          if header_locale && header_locale != I18n.default_locale
            # Redirect to language from "Accept-Language" header
            redirect_to "#{url_for(subdomain: header_locale, domain: request.domain).chomp '/'}#{request.original_fullpath}"
            logger.debug "Redirect to #{header_locale} subdomain from 'Accept-Language' header"
          end
        end
      else
        # Select language based on subdomain
        if I18n.available_locales.without(I18n.default_locale).include? request.subdomain.to_sym
          # Select specified language
          I18n.locale = request.subdomain.to_sym
          logger.debug "Set #{request.subdomain.to_sym} locale from subdomain"
        else
          # Redirect to base domain
          redirect_to "#{url_for(host: request.domain).chomp '/'}#{request.original_fullpath}"
          logger.debug "Redirect to base domain because of unavailable language"
          return if I18n.default_locale != request.subdomain.to_sym
        end
      end

      logger.debug "Set language_set on locale #{I18n.locale}"
      session[:language_set] = true
    end
end
