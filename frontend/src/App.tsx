import 'tea-component/dist/tea.css';

import React, { useEffect, useState } from 'react';
import { Card, Col, MetricsBoard, Row } from 'tea-component';
import { callAPI } from './runtime';
import image from './assets/image.svg';

export default function App() {
  const [data, setData] = useState({
    TotalCount: '-',
    RunningCount: '-',
    IsolationCount: '-',
    WillExpireCount: '-',
  });
  useEffect(() => {
    callAPI('GetLoadBalanceOverview').then((x) =>
      setData(x.ResponseBody.Response)
    );
  }, []);

  return (
    <Card>
      <Card.Body title="我的负载均衡">
        <Row showSplitLine>
          <Col>
            <MetricsBoard title="总数" value={data.TotalCount} unit="个" />
          </Col>
          <Col>
            <MetricsBoard title="运行中" value={data.RunningCount} unit="个" />
          </Col>
          <Col>
            <MetricsBoard
              title="已隔离"
              value={data.WillExpireCount}
              unit="个"
            />
          </Col>
          <Col>
            <MetricsBoard
              title="即将过期"
              value={data.WillExpireCount}
              unit="个"
            />
          </Col>
        </Row>
        <img src={image} />
      </Card.Body>
    </Card>
  );
}
