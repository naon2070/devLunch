cronJob = require('cron').CronJob

module.exports = (robot) ->
  #初期化時にコンソールにログを表示
  console.log("I'm ready!")

  # 毎週水曜日にリマインドを送信
  cronjob = new cronJob(
    cronTime: "0 0 10 * * wed"    # 実行する時間
    start:    true                # すぐにcronのjobを実行するかどうか
    timeZone: "Asia/Tokyo"        # タイムゾーン
    onTick: ->                    # 実行処理
      robot.send {room: '#08_tech_lightning'}, "Hey guys!!:yatta:\n\nIf you need a shuffle for lunch, talk to me \"shuffle\".\n\nIf today is not a shuffle lunch, just ignore me.:sunglasses:"
  )



  #-------------- ここ以下は対話用----------------------------------
  robot.respond /(シャッフル|shuffle)/i, (res) ->
    res.send "OK! will shuffle now!"
    setTimeout ->
      res.send "."
      setTimeout ->
        res.send "."
        setTimeout ->
          res.send "Ready!"
          setTimeout ->
            res.send createMessage()
          , 1000
        , 1500
      , 1000
    , 1000


  robot.respond /((お腹|おなか|腹|はら)(空いた|すいた|減った|へった)|hungry)/i, (res) ->
    res.send 'you need a shuffle？'

  robot.respond /(おすすめ|recommend|店|store|restaurant)/i, (res) ->
    res.send 'Defenitely Chinkashisai.'




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


createMessage = () ->
    #初期チームの状態をセット
    boss = [ "Masa-T" ]
    teamTM =  [ "Naoki", "Yuto", "BigCircle", "Dragon", "Ryosuke" ]
    teamTC =    [ "Koji", "Suguru", "Nori", "Masa-C" ]
    teamTP = ["Kyohey", "Kosuke", "Nobu"]
    notComeOften = ["Kanako", "Shinsuke", "AG", "Kaorin"]

    # 全チームを下記Arrayに格納する
    regularTeams = [ boss, teamTM, teamTC, teamTP, notComeOften ]
    shuffledRegTeams = []

    # regularTeams内の各チームの順番をバラバラにして、shuffledRegTeamsの配列に入れる
    for x in regularTeams
      randNum = Math.round((regularTeams.length - 1) * Math.random())
      shuffledRegTeams.push(regularTeams[randNum])
      regularTeams.splice(randNum, 1)

    # 作成するランチグループの数をセットし、その数だけメンバーが入るランチグループの箱（配列）の作成
    lunchGroupsNumber = 4 #作成するグループ数は変えるには、ここの数字を変える
    lunchGroups = []
    i = 0
    while i < lunchGroupsNumber
      lunchGroups.push([])
      i++

    #当日のランチグループを作成
    createLunchGroups(shuffledRegTeams, lunchGroups)

    #Slackに配信するbotのメッセージを作成
    message = "*Here you go!*:yatta:\n-----------------------------------------------------------\n"
    for lunchGroup, index in lunchGroups
      message += "【Group#{index + 1}】 #{lunchGroup.join(', ')}\n"
    message += '-----------------------------------------------------------'

    return message


