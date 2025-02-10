import { test, expect } from '@playwright/test';

test('color changer', async ({ page }) => {
  await page.goto('http://localhost:3000/sign-in.html');
  await page.getByLabel('Email').click();
  await page.getByLabel('Email').fill('testPro@email.com');
  await page.getByLabel('Password').click();
  await page.getByLabel('Password').fill('test');
  await page.getByRole('button', { name: 'Sign In' }).click();
  await page.getByText('T', { exact: true }).click();
  await page.getByRole('link', { name: 'Account' }).click();
  await page.getByText('T', { exact: true }).click();
  await page.locator('div:nth-child(6)').click();
  await page.getByText('T', { exact: true }).click();
  await page.locator('div:nth-child(10)').click();
  await page.getByRole('link', { name: 'Home' }).click();
});