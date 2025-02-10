import { test, expect } from '@playwright/test';

test('invalid email during registration', async ({ page }) => {
  await page.goto('http://localhost:3000/register.html');
  await page.getByLabel('Full Name').click();
  await page.getByLabel('Full Name').fill('ds');
  await page.getByLabel('Email').click();
  await page.getByLabel('Email').fill('ds');
  await page.getByLabel('Password', { exact: true }).click();
  await page.getByLabel('Password', { exact: true }).fill('ds');
  await page.getByLabel('Confirm Password').click();
  await page.getByLabel('Confirm Password').fill('ds');
  await page.getByRole('button', { name: 'Register' }).click();
});