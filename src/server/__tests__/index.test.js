const request = require('supertest');
const os = require('os');
const app = require('../index');

describe('GET /api/getUsername', () => {
  it('should return a JSON object with a username field', async () => {
    const res = await request(app).get('/api/getUsername');
    expect(res.status).toBe(200);
    expect(res.body).toHaveProperty('username');
  });

  it('should return the current OS username', async () => {
    const res = await request(app).get('/api/getUsername');
    expect(res.body.username).toBe(os.userInfo().username);
  });
});

describe('GET /unknown-route', () => {
  it('should return 404 for undefined routes', async () => {
    const res = await request(app).get('/api/nonexistent');
    expect(res.status).toBe(404);
  });
});
