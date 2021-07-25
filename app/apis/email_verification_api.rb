require 'resolv'

class EmailVerificationApi
  def valid_mx?(email)
    domain = email.split('@')[1]
    return if domain.nil?

    begin
      mx = Resolv::DNS.new.getresource(domain, Resolv::DNS::Resource::IN::MX)
    rescue
      return nil
    end

    mx.exchange.to_s
  end
end
