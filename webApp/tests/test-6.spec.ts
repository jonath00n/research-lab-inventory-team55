import { test, expect } from '@playwright/test';

test('checkout multiple with agreement', async ({ page }) => {
  await page.goto('http://localhost:3000/sign-in.html');
  await page.getByLabel('Email').click();
  await page.getByLabel('Email').fill('test@email.com');
  await page.getByLabel('Email').press('Tab');
  await page.getByLabel('Password').fill('test');
  await page.getByRole('button', { name: 'Sign In' }).click();
  await page.getByRole('row', { name: 'Resistors Assorted resistor' }).getByRole('spinbutton').fill('3');
  await page.getByRole('row', { name: 'Resistors Assorted resistor' }).getByRole('button').click();
  await page.getByRole('row', { name: 'Breadboard 830-point' }).getByRole('button').click();
  await page.locator('i').click();
  await page.getByLabel('I agree that the following').check();
  await page.getByRole('button', { name: 'Checkout' }).click();
});