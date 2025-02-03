import { test, expect } from '@playwright/test';

test('failed sign-in test', async ({ page }) => {
  await page.goto('http://localhost:3000/');
  await page.locator('#user-icon').click();
  await page.locator('#user-icon').click();
  await page.locator('#user-icon').click();
  await page.getByRole('link', { name: 'Sign in' }).click();
  await page.getByLabel('Email').click();
  await page.getByLabel('Email').fill('test');
  await page.getByLabel('Email').press('Tab');
  await page.getByLabel('Password').fill('test@email.com');
  await page.getByLabel('Password').press('Enter');
  await page.getByRole('button', { name: 'Sign In' }).click();
});