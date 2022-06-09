// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration
module.exports = {
  content: ['./js/**/*.js', '../lib/*_web.ex', '../lib/*_web/**/*.*ex'],
  safelist: [
    // 'border-green-700',
    // 'border-blue-800',
    // 'border-indigo-600',
    // 'border-purple-700',
    // 'border-pink-600',

    // 'text-green-700',
    // 'text-blue-800',
    // 'text-indigo-600',
    // 'text-purple-700',
    // 'text-pink-600',
    'grid-cols-3',
    'grid-cols-4',
    'grid-cols-5',
    'grid-cols-6', // invalid game size
    'bg-[#a4deff]',
    'bg-[#f9cedf]',
    'bg-[#d3c5f1]',
    'bg-[#acc9f5]',
    'bg-[#aeeace]',
    'bg-[#96d7b9]',
    'bg-[#fce8bd]',
    'bg-[#fcd8ac]',
    'bg-[#fefbe7]', // invalid player color
    'border-[#a4deff]',
    'border-[#f9cedf]',
    'border-[#d3c5f1]',
    'border-[#acc9f5]',
    'border-[#aeeace]',
    'border-[#96d7b9]',
    'border-[#fce8bd]',
    'border-[#fcd8ac]',
    'border-[#fefbe7]', // invalid player color
    'ring-[#a4deff]',
    'ring-[#f9cedf]',
    'ring-[#d3c5f1]',
    'ring-[#acc9f5]',
    'ring-[#aeeace]',
    'ring-[#96d7b9]',
    'ring-[#fce8bd]',
    'ring-[#fcd8ac]',
    'ring-[#fefbe7]', // invalid player color
    {
      pattern: /(border|text)-(green|blue|indigo|purple|pink)-(6|7|8)00/
    }
  ],
  theme: {
    extend: {
      colors: {
        'cool-gray': {
          '50': '#f8fafc',
          '100': '#f1f5f9',
          '200': '#e2e8f0',
          '300': '#cfd8e3',
          '400': '#97a6ba',
          '500': '#64748b',
          '600': '#475569',
          '700': '#364152',
          '800': '#27303f',
          '900': '#1a202e'
        }
      }
    }
  },
  variants: {
    extend: {
      //backgroundColor: ['responsive', 'hover', 'focus', 'active']
      backgroundColor: ['active', 'disabled'],
      opacity: ['disabled'],
      cursor: ['disabled']
    }
  },
  plugins: [require('@tailwindcss/forms')]
}
