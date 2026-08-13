import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    {
      duration: '15s',
      target: 5,
    },
    {
      duration: '30s',
      target: 20,
    },
    {
      duration: '15s',
      target: 0,
    },
  ],

  thresholds: {
    http_req_failed: [
      'rate<0.01',
    ],

    http_req_duration: [
      'p(95)<750',
    ],

    checks: [
      'rate>0.99',
    ],
  },
};

const BASE_URL =
  __ENV.BASE_URL || 'http://localhost:8080';

export default function () {
  const healthResponse =
    http.get(`${BASE_URL}/actuator/health`);

  check(healthResponse, {
    'health returns 200': (response) =>
      response.status === 200,

    'application is UP': (response) =>
      response.body.includes('UP'),
  });

  const versionResponse =
    http.get(`${BASE_URL}/api/version`);

  check(versionResponse, {
    'version returns 200': (response) =>
      response.status === 200,
  });

  const todosResponse =
    http.get(`${BASE_URL}/api/todos`);

  check(todosResponse, {
    'todos returns 200': (response) =>
      response.status === 200,
  });

  sleep(1);
}
