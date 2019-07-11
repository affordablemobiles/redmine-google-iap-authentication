# Google IAP Authentication for Redmine

This plugin provides stateless logins for Redmine when it running behind Google's IAP (Identity Aware Proxy).

### Security Considerations

It reads the user information in the `X-Goog-Authenticated-User-Email` header, which isn't technically validation.

For proper security, we assume you are running Redmine with an nginx reverse proxy, which performs the actual IAP validation, using the signed JWT.

See: https://github.com/imkira/gcp-iap-auth