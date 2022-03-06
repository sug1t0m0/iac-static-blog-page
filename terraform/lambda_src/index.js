aws.config.region = 'ap-northeast-1';

exports.handler = async (event, context, callback) => {

    console.log(JSON.stringify(event));

    const res = {
        statusCode: 200,
    }

    console.log(`env: ${process.env.env}`);
};
