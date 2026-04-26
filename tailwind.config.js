/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ['./src/**/*.{js,ts,jsx,tsx,mdx}'],
  theme: {
    extend: {
      colors: { deep: '#060e0a', forest: '#0d2318', emerald: '#1a4a2e', gold: '#c9a84c', 'gold-light': '#e8c97a', cream: '#f0ead8', teal: '#2dd4bf' },
      fontFamily: { heading: ['Cormorant Garamond', 'serif'], body: ['Montserrat', 'sans-serif'] },
    },
  },
  plugins: [],
};
