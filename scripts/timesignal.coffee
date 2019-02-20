cronJob = require('cron').CronJob

module.exports = (robot) ->

    cronjob = new cronJob(
      cronTime: "0 0 * * * *"    # 実行する時間
      start:    true                # すぐにcronのjobを実行するかどうか
      timeZone: "Asia/Tokyo"        # タイムゾーン
      onTick: ->                    # 実行処理
        robot.send {room: "#dev_ミニランチボット開発"}, createMessage()
    )

legend = "LEGEND_Kataoka"
techMasterTeam =  [ "まるちゃん", "DRAGON", "たかいっち", "きょんきょん" ]
techCampTeam =    [ "TEXAS", "みうらさん", "だいすけ", "コウジ" ]
teams = [ techMasterTeam, techCampTeam ]

teamA = []
teamB = []

lunchTeam = [ teamA, teamB ]

shuffleDevTeam = ()->
  counter = 0
  for team, indexTeam in teams
    array = []
    for member, index in team
      console.log(counter)
      randNum = team.length * Math.random()
      team[randNum]
      shuffle(counter, member)
      counter++
  shuffle(counter, legend)


shuffle = (counter, member)->
  index = counter % lunchTeam.length
  lunchTeam[index].push(member)


createMessage = ()->
  message = ''
  shuffleDevTeam()
  console.log('after shuffle')
  for team, index in lunchTeam
    message += "team#{index + 1}: #{team.toString()}\n"

  return message



