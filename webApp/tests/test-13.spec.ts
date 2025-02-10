import { test, expect } from '@playwright/test';

test('filtering search results', async ({ page }) => {
  await page.goto('http://localhost:3000/');
  await page.locator('#user-icon').click();
  await page.getByRole('link', { name: 'Sign in' }).click();
  await page.getByLabel('Email').click();
  await page.getByLabel('Email').fill('testPro@email.com');
  await page.getByLabel('Email').press('Tab');
  await page.getByLabel('Password').fill('test');
  await page.getByLabel('Password').press('Enter');
  await page.getByRole('button', { name: 'Sign In' }).click();
  await page.getByText('Category: All Electronics Prototyping Soldering Power Supplies Supplier: All').click();
  await page.getByLabel('Supplier:').selectOption('Tech Wizard');
  await page.getByLabel('Availability:').selectOption('in-stock');
  await page.getByLabel('Category:').selectOption('Electronics');
  await page.getByLabel('Supplier:').selectOption('Power UP');
  await page.getByLabel('Category:').selectOption('Power Supplies');
  await page.getByRole('button', { name: 'Add to Cart' }).click();
  await page.locator('i').click();
  await page.getByRole('button', { name: 'Checkout' }).click();
});