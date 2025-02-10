import { test, expect } from '@playwright/test';

test('basic navigation test', async ({ page }) => {
  await page.goto('http://localhost:3000/');
  await page.locator('#user-icon').click();
  await page.getByRole('link', { name: 'Sign in' }).click();
  await page.getByRole('link', { name: 'Register', exact: true }).click();
  await page.getByRole('link', { name: 'Center Image' }).click();
  await page.locator('#user-icon').click();
  await page.getByRole('link', { name: 'About' }).click();
  await page.getByRole('link', { name: 'Home' }).click();
});