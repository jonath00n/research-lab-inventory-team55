import { test, expect } from '@playwright/test';

test('reroute from management when not signed in', async ({ page }) => {
  await page.goto('http://localhost:3000/management.html');
});