cronJob = require('cron').CronJob

module.exports = (robot) ->

  #ランチは隔週なので、次回をランチにする場合はtrue、ランチを休みにする場合はfalseにしておく
  week_check = [false]
  cronjob = new cronJob(
    cronTime: "0 0 10 * * wed"    # 実行する時間
    start:    true                # すぐにcronのjobを実行するかどうか
    timeZone: "Asia/Tokyo"        # タイムゾーン
    onTick: ->                    # 実行処理
      robot.send {room: "#08_tech_lightning"}, createMessage(week_check)
  )

  #初期化時にSlackにメッセージ表示
  console.log("I'm ready! and this weak is #{week_check}")


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


createMessage = (week_check)->

  if week_check[0]
    #初期チームの状態をセット
    boss = [ "片岡さん" ]
    teamTM =  [ "丸下さん", "井上さん", "高井さん", "瀬尾さん" ]
    teamTC =    [ "中田さん", "三浦さん", "西森さん", "浦田さん" ]
    teamCoachStand = [ "福田さん" ]
    regularTeams = [ teamTM, teamTC, teamCoachStand, boss ]

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
    message = ":yatta:*＼Yay! Today's Shuffle lunch day!／*:yatta:\n\n\n\n今日は開発メンバーのシャッフルランチの日だよ！\n気になる今日のランチグループは下記だよ！\n-----------------------------------------------------------\n"
    for lunchGroup, index in lunchGroups
      message += "グループ#{index + 1}: #{lunchGroup.toString()}\n"
    message += '-----------------------------------------------------------'

    week_check[0] = !week_check[0]
    console.log(message)
    return message

  else
    week_check[0] = !week_check[0]
    message = '今日はTechDiscussionなので、シャッフルランチはお休みですm(__)m'

    console.log(message)
    return message


# 動作チェック用
# do ->
  # week_check = [true]
  # console.log("I'm ready! and this weak is #{week_check}")
  # createMessage(week_check)
  # createMessage(week_check)
  # createMessage(week_check)
  # createMessage(week_check)
  # return
