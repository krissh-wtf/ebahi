from std/strformat import `&`

var
  token*:                   string

const
  # useragent
  userAgent*:               string = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36"
  contentType*:             string = "application/json"

  # api version
  apiVersion*:              int    =  9

  # api endpoints
  loginUrl*:                string =  &"https://discord.com/api/v{$apiVersion}/auth/login"
  logoutUrl*:               string =  &"https://discord.com/api/v{$apiVersion}/auth/logout"
  totpUrl*:                 string =  &"https://discord.com/api/v{$apiVersion}/auth/mfa/totp"
  smsUrl*:                  string =  &"https://discord.com/api/v{$apiVersion}/auth/mfa/sms"
  meUrl*:                   string =  &"https://discord.com/api/v{$apiVersion}/users/@me"
  settingsUrl*:             string =  &"https://discord.com/api/v{$apiVersion}/users/@me/settings" 
  relationshipsUrl*:        string =  &"https://discord.com/api/v{$apiVersion}/users/@me/relationships"
  relationshipsInviteUrl*:  string =  &"https://discord.com/api/v{$apiVersion}/users/@me/invites"
  guildsUrl*:               string =  &"https://discord.com/api/v{$apiVersion}/users/@me/guilds"
  guildMembersUrl*:         string =  &"https://discord.com/api/v{$apiVersion}/guilds/$/members"
  typingUrl*:               string =  &"https://discord.com/api/v{$apiVersion}/channels/$/typing"


type MfaMethod* = enum
  totp, sms, none
