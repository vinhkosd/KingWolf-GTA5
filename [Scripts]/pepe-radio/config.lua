
--- Change DBFW to your core name

---- Done by Dolaji

---- Discord - https://discord.gg/qZQfHuYWSm



Config = {}

Config.RestrictedChannels = 10 -- channels that are encrypted (EMS, Fire and police can be included there) if we give eg 10, channels from 1 - 10 will be encrypted

Config.MaxFrequency = 500

Config.messages = {
  ['not_on_radio'] = 'Bạn không kết nối với kênh nào',
  ['on_radio'] = 'Của bạn đã kết nối với kênh: <b>',
  ['joined_to_radio'] = 'Đã kết nối tới: <b>',
  ['restricted_channel_error'] = 'Bạn không thể kết nối với tín hiệu này!',
  ['you_on_radio'] = 'Của bạn đã kết nối với tín hiệu này: <b>',
  ['you_leave'] = 'Bạn đã thoát kênh: <b>'
}