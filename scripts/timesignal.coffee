cronJob = require('cron').CronJob

module.exports = (robot) ->

    cronjob = new cronJob(
      cronTime: "0 15 11 * * 3"    # 実行する時間
      start:    true                # すぐにcronのjobを実行するかどうか
      timeZone: "Asia/Tokyo"        # タイムゾーン
      onTick: ->                    # 実行処理
        robot.send {room: "#dev_ミニランチボット開発"}, createMessage()
    )


createLunchGroups = (regularTeams, lunchGroups)->
  counter = 0
  for team in regularTeams
    for x in team
      # 初期チームからランダムにメンバーを選択
      randNum = Math.round((team.length - 1) * Math.random())
      pickedMember = team[randNum]

      # 選択したメンバーを元の配列から削除（再度同じメンバーが重複して呼ばれないように）
      team.splice(randNum, 1)

      # 選択したメンバーをランチグループに追加
      addMemberToLunchGroup(counter, pickedMember, lunchGroups)

      counter++


addMemberToLunchGroup = (counter, pickedMember, lunchGroups)->
  #全てのランチグループのメンバー数が均等になるように、順番にランチグループを指定し、メンバーを追加
  index = counter % lunchGroups.length
  lunchGroups[index].push(pickedMember)


createMessage = ()->
  #初期チームの状態をセット
  boss = [ "片岡さん" ]
  teamTM =  [ "丸下さん", "井上さん", "高井さん", "瀬尾さん" ]
  teamTC =    [ "中田さん", "三浦さん", "西森さん", "浦田さん" ]
  regularTeams = [ teamTM, teamTC, boss ]

  # 作成するランチグループの数をセットし、その数だけメンバーが入るランチグループの箱（配列）の作成
  lunchGroupsNumber = 2 #作成するグループ数は変えるには、ここの数字を変える
  lunchGroups = []
  i = 0
  while i < lunchGroupsNumber
    lunchGroups.push([])
    i++

  #当日のランチグループを作成
  createLunchGroups(regularTeams, lunchGroups)

  #Slackに配信するbotのメッセージを作成
  message = ''
  for lunchGroup, index in lunchGroups
    message += "lunchGroup#{index + 1}: #{lunchGroup.toString()}\n"

  console.log(message)
  return message


