module.exports = {
    updatePlayerCount: (client, seconds) => {
        const interval = setInterval(function setStatus() {
            status = `${GetNumPlayerIndices()} online`
            //console.log(status)
            client.user.setActivity(status, {type: 'PLAYING'})
            return setStatus;
        }(), seconds * 1000)
    }
}