import { test, expect } from '@playwright/test';

test('proper loading of complex css', async ({ page }) => {
  await page.goto('http://localhost:3000/faq.html');
  await page.getByRole('link', { name: 'Home' }).click();
});