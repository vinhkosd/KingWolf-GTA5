//////////////////////////////////////////
//           Discord Whitelist          //
//////////////////////////////////////////

/// Config Area ///

var guild = "916665114034319441";//old KINGWOLF 905682786134941717
var botToken = "OTIzNDcyODg2NDYxNzYzNTg0.YcQhJQ.rQEcJWkMnbDnVf0wt_y8KF4PIUs";

var whitelistRoles = [ // Roles by ID that are whitelisted.
    "922812371792179221"//old role - 905783237547286528
]

var blacklistRoles = [ // Roles by Id that are blacklisted.
    "923579749878616115"//old role - 905783410377764866
]

var notWhitelistedMessage = "Vui lòng truy cập link Discord https://discord.gg/c9J3R3SMZb để được đăng ký whitelist. Nếu bạn đã được cấp whitelist, hãy thử tắt FiveM và mở lại Discord trước sau đó mở FiveM để kết nối!"
var noGuildMessage = "Guild Not Detected. It seems you're not in the guild for this community."
var blacklistMessage = "Bạn đã bị cấm khỏi máy chủ"
var debugMode = true


/*

NOTES NOTES NOTES

Red Console Log === Member Denied Access
Yellow Console Log === Issue Determining Access
Green Console Log === Member Granted Access
Magenta Console Log === Blacklisted Member Denied Access
Blue Console Log === Script Information (error, etc)

*/


/// CODE DONT TOUCH THIS!!!! ///
/// CODE DONT TOUCH THIS!!!! ///
/// CODE DONT TOUCH THIS!!!! ///
const axios = require('axios').default;
// axios.defaults.baseURL = 'https://discord.com/api/v8';
axios.defaults.headers = {
    'Content-Type': 'application/json',
    Authorization: `Bot ${botToken}`
};
function getUserDiscord(source) {
    if(typeof source === 'string') return source;
    if(!GetPlayerName(source)) return false;
    for(let index = 0; index <= GetNumPlayerIdentifiers(source); index ++) {
        if (GetPlayerIdentifier(source, index) && GetPlayerIdentifier(source, index).indexOf('discord:') !== -1) return GetPlayerIdentifier(source, index).replace('discord:', '');
    }
    return false;
}
on('playerConnecting', (name, setKickReason, deferrals) => {
    let src = global.source;
    deferrals.defer();
    var userId = getUserDiscord(src);

    setTimeout(() => {
        // deferrals.update(`${name}`)
        deferrals.update(`Checking Whitelist`)
        setTimeout(async function() {
            if(userId) {
                axios('https://discord.com/api/v8' + `/guilds/${guild}/members/${userId}`).then((resDis) => {
                    if(!resDis.data) {
                        if(debugMode) console.log(`^1'${name}' with ID '${userId}' cannot be found in the assigned guild and was not granted access.^7`);
                        return deferrals.done(notWhitelistedMessage);
                    }
                    const hasRole = typeof whitelistRoles === 'string' ? resDis.data.roles.includes(whitelistRoles) : resDis.data.roles.some((cRole, i) => resDis.data.roles.includes(whitelistRoles[i]));
                    const hasBlackRole = typeof blacklistRoles === 'string' ? resDis.data.roles.includes(blacklistRoles) : resDis.data.roles.some((cRole, i) => resDis.data.roles.includes(blacklistRoles[i]));
                    if(hasBlackRole) {
                        if(debugMode) console.log(`^6'${name}' with ID '${userId}' is blacklisted to join this server.^7`);
                        return deferrals.done(blacklistMessage);
                    }
                    if(hasRole) {
                        if(debugMode) console.log(`^2'${name}' with ID '${userId}' was granted access and passed the whitelist.^7`);
                        return deferrals.done();
                    } else {
                        if(debugMode) console.log(`^6'${name}' with ID '${userId}' is not whitelisted to join this server.^7`);
                        return deferrals.done(notWhitelistedMessage);
                    }
                }).catch((err) => {
                    if(debugMode) console.log(`^4There was an issue with the Discord API request. Is the guild ID & bot token correct?^7`);
                    return deferrals.done(notWhitelistedMessage);
                });
            } else {
                if(debugMode) console.log(`^1'${name}' was not granted access as a Discord identifier could not be found.^7`);
                return deferrals.done(`Vui lòng bật discord trước khi khởi động FiveM - https://docs.faxes.zone/c/fivem/debugging-discord - Discord: https://discord.gg/c9J3R3SMZb`);
            }
        }, 0)
    }, 0)
})