import { test, expect } from '@playwright/test';

test('no matching passwords register', async ({ page }) => {
  await page.goto('http://localhost:3000/register.html');
  await page.getByLabel('Full Name').click();
  await page.getByLabel('Full Name').fill('ds');
  await page.getByLabel('Full Name').press('Tab');
  await page.getByLabel('Email').fill('ds@email.com');
  await page.getByLabel('Email').press('Tab');
  await page.getByLabel('Password', { exact: true }).fill('ds');
  await page.getByLabel('Password', { exact: true }).press('Tab');
  await page.getByLabel('Confirm Password').fill('sd');
  await page.getByRole('button', { name: 'Register' }).click();
});