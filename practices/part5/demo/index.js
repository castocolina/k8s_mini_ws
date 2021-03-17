const CronJob = require('cron').CronJob;
const winston = require('winston');
const nconf = require('nconf');

nconf.defaults({
    'LOGS_FOLDER': 'logs'
  });

const LOGS_FOLDER = nconf.get('LOGS_FOLDER');
console.log(`logs folder target: ${LOGS_FOLDER}`)


const logConfiguration = {
    transports: [
        new winston.transports.Console(),
        // new winston.transports.Console({
        //     level: 'debug'
        // }),
        new winston.transports.File({
            level: 'debug',
            // Create the log directory if it does not exist
            filename: `${LOGS_FOLDER}/output.log`,
            maxsize: 1024 * 5,
            maxFiles: 100,
            tailable: true
        })
    ],
    format: winston.format.combine(
        winston.format.label({
            label: `Label🏷️`
        }),
        winston.format.timestamp({
           format: 'MMM-DD-YYYY HH:mm:ss'
       }),
        winston.format.printf(info => `${info.level}: ${info.label}: ${[info.timestamp]}: ${info.message}`),
    )
};

const logger = winston.createLogger(logConfiguration);

var job = new CronJob('* * * * * *', function() {
  logger.info('You will see this message every second *********************************************************');
}, null, true, 'America/Los_Angeles');
job.start();