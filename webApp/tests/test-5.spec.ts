import { test, expect } from '@playwright/test';

test('sign-in success', async ({ page }) => {
  await page.goto('http://localhost:3000/sign-in.html');
  await page.getByLabel('Email').click();
  await page.getByLabel('Email').fill('test@email.com');
  await page.getByLabel('Email').press('Tab');
  await page.getByLabel('Password').fill('test');
  await page.getByRole('button', { name: 'Sign In' }).click();
  await page.getByText('T', { exact: true }).click();
  await page.getByRole('link', { name: 'Account' }).click();
  await page.getByRole('link', { name: 'Home' }).click();
});