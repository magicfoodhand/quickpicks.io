require './shared'

URL = URI("https://www.calottery.com/sitecore/content/Miscellaneous/download-numbers/?GameName=daily-3&Order=No")
COOKIE = 'website%23sc_wede=1; BNES_website%23sc_wede=jK35WmRnfsn19RQC4Rv%2FGbX41aI8DjiniYQQ3QqxJMllPSYZXZU%2BVRALYbXpKNHf; ASP.NET_SessionId=vqrry5ind20gawrooil4f355; platform-lang=en'

california_lottery ARGV.first, URL, COOKIE