import { test, expect } from '@playwright/test';

test('add item modal load correctly', async ({ page }) => {
  await page.goto('http://localhost:3000/sign-in.html');
  await page.getByLabel('Email').click();
  await page.getByLabel('Email').fill('testPro@email.com');
  await page.getByLabel('Email').press('Tab');
  await page.getByLabel('Password').fill('test');
  await page.getByRole('button', { name: 'Sign In' }).click();
  await page.getByText('T', { exact: true }).click();
  await page.getByRole('link', { name: 'Management' }).click();
  await page.getByText('Items').click();
  await page.getByRole('button', { name: '+ New Item' }).click();
  await page.locator('#close-new-item-btn').click();
});