const mysqldump = require('mysqldump');
const cron = require('node-cron');
const enviarEmail = require('./mail');
const FormataData = () => {
    const dia = new Date().toISOString()
    const diaA = dia.slice(0, 10)
    const diaH = dia.slice(11, 13)
    const diaM = dia.slice(14, 16)
    const diaS = dia.slice(17, 19)
    return `${diaA}_${diaH}_${diaM}_${diaS}`
}
const db = `./backup/${FormataData()}_dump.sql`
const geradb = async () => {
    const result = await mysqldump({
        connection: {
            host: 'mail-mysql-1',
            user: 'root',
            password: 'my-secret-pw',
            database: 'phpipam',
        },
        dumpToFile: db,
    });
    return result
}
const geraBkp = async () => cron.schedule('* * * * *', () => {
    geradb().then(
        result => {
            return enviarEmail(db).then(console.log("email enviado com sucesso"))
        })
        .catch(e => console.log(e))
});

module.exports = geraBkp