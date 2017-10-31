module.exports = {
    extends: ['@financial-times/de-tooling', 'prettier'],
    plugins: ['prettier'],
    rules: {
        'prettier/prettier': 'error',
        'no-use-before-define': 'off',
        'no-underscore-dangle': 'warn'
    }
};
