cronJob = require('cron').CronJob

module.exports = (robot) ->

    cronjob = new cronJob(
      cronTime: "0 15 11 * * 3"    # 実行する時間
      start:    true                # すぐにcronのjobを実行するかどうか
      timeZone: "Asia/Tokyo"        # タイムゾーン
      onTick: ->                    # 実行処理
        robot.send {room: "#dev_ミニランチボット開発"}, createMessage()
    )

boss = "片岡さん"
teamTM =  [ "丸下さん", "井上さん", "高井さん", "瀬尾さん" ]
teamTC =    [ "中田さん", "三浦さん", "西森さん", "浦田さん" ]
regularTeams = [ teamTM, teamTC ]

# ランチのグループ数
lunchGroupsNumber = 2
lunchGroups = []
num = 0
while num < lunchGroupsNumber
  lunchGroups.push([])
  num++
num = 0

shuffleDevTeam = (copiedRegTeams)->
  counter = 0
  for copiedRegTeam in copiedRegTeams
    array = []
    for member in copiedRegTeam
      randNum = Math.round((copiedRegTeam.length - 1) * Math.random())
      pickedMember = copiedRegTeam[randNum]
      copiedRegTeam.splice(randNum, 1)
      addMemberToLunchGroup(counter, pickedMember)
      counter++
  addMemberToLunchGroup(counter, boss)


addMemberToLunchGroup = (counter, pickedMember)->
  index = counter % lunchGroups.length
  lunchGroups[index].push(pickedMember)


createMessage = ()->
  message = ''
  copiedRegTeams = regularTeams.slice(0)
  shuffleDevTeam(copiedRegTeams)
  for lunchGroup, index in lunchGroups
    message += "lunchGroup#{index + 1}: #{lunchGroup.toString()}\n"

  console.log(message)
  return message


