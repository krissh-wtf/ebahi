import std/[httpclient, json]

var token*: string = ""
type DiscordClient* = object
  userAgent: string = ""

  loginUrl: string = "https://discord.com/api/v9/auth/login"
  totpUrl: string = "https://discord.com/api/v9/auth/mfa/totp"
  logoutUrl: string = "https://discord.com/api/v9/auth/logout"

  meUrl: string = "https://discord.com/api/v9/users/@me"
  settingsUrl: string = "https://discord.com/api/v9/users/@me/settings"

  relationshipsUrl: string = "https://discord.com/api/v9/users/@me/relationships"
  mutualRelationships: string = "https://discord.com/api/v9/users/$id/relationships"
  relationshipsInviteUrl: string = "https://discord.com/api/v9/users/@me/invites"

  guildsUrl: string = "https://discord.com/api/v9/users/@me/guilds"
  guildsMembersUrl: string = "https://discord.com/api/v9/guilds/$id/members"
    # % ["{ID DE SERVER}"]

  typingUrl: string = "https://discord.com/api/v9/channels/$id/typing"
    # % ["{ID DE CHAINE}"]

var client = newHttpClient()
client.headers =
  newHttpHeaders(
    {
      "User-Agent":
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36",
      "Content-Type": "application/json",
      "Authorization": token
    }
  )

proc login*(
    self: DiscordClient, email: string, password: string, totpCode: string = ""
): bool =
  let body = %*{"login": email, "password": password}

  let request = client.request(self.loginUrl, HttpPost, $body)
  let response = parseJson(request.body)

  if request.code == Http200:
    if response.contains "mfa":
      if response.contains "totp":
        let ticket = response["ticket"].getStr()

        let body = %*{"code": totpCode, "ticket": ticket}

        let request = client.request(self.totpUrl, HttpPost, $body)
        let response = parseJson(request.body)

        if request.code == Http200:
          token = $response["token"]
          return true
    else:
      token = $response["token"]
      return true

proc login*(self: DiscordClient, dToken: string): bool =
  token = dToken
  let tempHeaders =
    newHttpHeaders(
      {
        "User-Agent":
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36",
        "Content-Type": "application/json",
        "Authorization": token
      }
    )

  let request = client.request(self.meUrl, HttpGet, headers = tempHeaders)

  if request.code == Http200:
    return true

proc logout*(self: DiscordClient, token: string = token): bool =
  let request = client.request(self.logoutUrl, HttpPost)

  if request.code == Http200:
    return true
