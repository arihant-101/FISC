const schedule = require('node-schedule');
const client = require('./pgdatabase');

const updateInvestmentsJob = schedule.scheduleJob('0 0 1 * *', async function () {
  console.log('Running updateInvestmentsJob');

  try {
    await client.query(
      'UPDATE public."investments" SET "DurationLeft" = "DurationLeft" - 1 WHERE "DurationLeft" > 0'
    );
  } catch (error) {
    console.error('Error updating investments:', error);
  }
});

module.exports = {
  updateInvestmentsJob,
};
