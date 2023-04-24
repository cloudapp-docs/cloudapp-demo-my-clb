const express = require('express');
const bodyParser = require('body-parser');
const tencentcloud = require('tencentcloud-sdk-nodejs');
const { getCredential } = require('./credential');

function main() {
  const app = express();

  app.use(async (req, res, next) => {
    res.on('finish', () =>
      console.log(
        `${new Date().toLocaleString('zh-cn')} ${req.method} ${
          req.originalUrl
        } ${res.statusCode}`
      )
    );
    await next();
  });
  app.use(bodyParser.json());
  app.use('/api', async (req, res) => {
    try {
      const credential = await getCredential();
      console.log('credential', credential);

      const {
        TmpSecretId: secretId,
        TmpSecretKey: secretKey,
        Token: token,
      } = credential;

      const clb = new tencentcloud.clb.v20180317.Client({
        credential: { secretId, secretKey, token },
        region: 'ap-guangzhou',
        profile: {
          httpProfile: {
            endpoint: 'clb.internal.tencentcloudapi.com',
            protocol: 'https://',
          },
        },
      });

      const balance = await clb.DescribeLoadBalancerOverview();

      res.send({ Response: balance });
    } catch (err) {
      const { message: Message } = err || { message: '发生未知错误' };
      res.status(500).send({ Error: { Message } });
    }
  });

  const port = process.env.SERVER_PORT || 8000;
  app.listen(port);
  console.log(`Server listening at ${port}`);
}

main();
