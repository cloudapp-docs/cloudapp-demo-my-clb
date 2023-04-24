const bent = require('bent');

// CAM_ROLE 在 Charts 配置的容器环境变量内传入
const CAM_ROLE = process.env.CAM_ROLE;
const credentialUrl = `http://metadata.tencentyun.com/meta-data/cam/security-credentials/${CAM_ROLE}`;
const getCredential = bent('json', 'GET', credentialUrl, 200);

module.exports = { getCredential };
