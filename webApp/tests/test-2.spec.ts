import { test, expect } from '@playwright/test';

test('Reroute from account when not signed in', async ({ page }) => {
  await page.goto('http://localhost:3000/');
  await page.locator('#user-icon').click();
  await page.getByRole('link', { name: 'About' }).click();
  await page.goto('http://localhost:3000/account.html');
});