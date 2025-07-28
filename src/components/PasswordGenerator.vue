<template>
  <div class="max-w-2xl mx-auto">
    <!-- Header -->
    <div class="text-center mb-8">
      <h1 class="text-4xl md:text-5xl font-bold text-white mb-4">
        Password<span class="text-primary-500">GEN</span>
      </h1>
      <p class="text-gray-400 text-lg">
        Generate secure passwords with customizable options
      </p>
    </div>

    <!-- Main Card -->
    <div class="card p-8 space-y-8">
      <!-- Generated Password Display -->
      <div class="space-y-4">
        <label class="block text-sm font-medium text-gray-300">
          Generated Password
        </label>
        <div class="relative">
          <input
            :value="generatedPassword"
            readonly
            class="w-full bg-dark-800 border border-dark-600 rounded-xl px-4 py-4 text-lg font-mono text-white focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent pr-16"
            :placeholder="generatedPassword || 'Click generate to create a password'"
          />
          <button
            @click="copyToClipboard"
            :disabled="!generatedPassword"
            class="absolute right-2 top-1/2 transform -translate-y-1/2 p-2 rounded-lg transition-all duration-200"
            :class="[
              generatedPassword 
                ? 'text-primary-500 hover:bg-dark-700 hover:text-primary-400' 
                : 'text-gray-600 cursor-not-allowed'
            ]"
            title="Copy to clipboard"
          >
            <svg v-if="!copied" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z"></path>
            </svg>
            <svg v-else class="w-5 h-5 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
            </svg>
          </button>
        </div>
        <div v-if="copied" class="text-sm text-green-500 animate-bounce-subtle">
          Password copied to clipboard!
        </div>
      </div>

      <!-- Password Length Slider -->
      <div class="space-y-4">
        <div class="flex justify-between items-center">
          <label class="text-sm font-medium text-gray-300">
            Password Length
          </label>
          <span class="text-primary-500 font-bold text-lg">
            {{ passwordLength }}
          </span>
        </div>
        <input
          v-model="passwordLength"
          type="range"
          min="8"
          max="128"
          class="input-range"
        />
        <div class="flex justify-between text-xs text-gray-500">
          <span>8</span>
          <span>128</span>
        </div>
      </div>

      <!-- Character Options -->
      <div class="space-y-4">
        <label class="text-sm font-medium text-gray-300">
          Character Types
        </label>
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <label class="flex items-center space-x-3 cursor-pointer group">
            <input
              v-model="includeUppercase"
              type="checkbox"
              class="checkbox-custom"
            />
            <span class="text-gray-300 group-hover:text-white transition-colors">
              Uppercase Letters (A-Z)
            </span>
          </label>
          
          <label class="flex items-center space-x-3 cursor-pointer group">
            <input
              v-model="includeLowercase"
              type="checkbox"
              class="checkbox-custom"
            />
            <span class="text-gray-300 group-hover:text-white transition-colors">
              Lowercase Letters (a-z)
            </span>
          </label>
          
          <label class="flex items-center space-x-3 cursor-pointer group">
            <input
              v-model="includeNumbers"
              type="checkbox"
              class="checkbox-custom"
            />
            <span class="text-gray-300 group-hover:text-white transition-colors">
              Numbers (0-9)
            </span>
          </label>
          
          <label class="flex items-center space-x-3 cursor-pointer group">
            <input
              v-model="includeSymbols"
              type="checkbox"
              class="checkbox-custom"
            />
            <span class="text-gray-300 group-hover:text-white transition-colors">
              Symbols (!@#$%^&*)
            </span>
          </label>
        </div>
      </div>

      <!-- Generate Button -->
      <div class="pt-4">
        <button
          @click="generatePassword"
          :disabled="!hasValidOptions"
          class="w-full btn-primary text-lg"
          :class="{ 'opacity-50 cursor-not-allowed': !hasValidOptions }"
        >
          <span class="flex items-center justify-center space-x-2">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path>
            </svg>
            <span>Generate Secure Password</span>
          </span>
        </button>
      </div>

      <!-- Password Strength Indicator -->
      <div v-if="generatedPassword" class="space-y-2">
        <div class="flex justify-between items-center">
          <span class="text-sm text-gray-400">Password Strength</span>
          <span :class="strengthColor" class="text-sm font-medium">
            {{ passwordStrength }}
          </span>
        </div>
        <div class="w-full bg-dark-700 rounded-full h-2">
          <div
            :class="[strengthColor.replace('text-', 'bg-'), 'strength-bar-shadow']"
            class="h-2 rounded-full transition-all duration-500"
            :style="{ width: strengthPercentage + '%' }"
          ></div>
        </div>
      </div>
    </div>

    <!-- Footer -->
    <div class="text-center mt-8 text-gray-500 text-sm">
      <p>🔒 All passwords are generated locally in your browser for maximum security</p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'

// Reactive state
const generatedPassword = ref('')
const passwordLength = ref(16)
const includeUppercase = ref(true)
const includeLowercase = ref(true)
const includeNumbers = ref(true)
const includeSymbols = ref(true)
const copied = ref(false)

// Character sets
const uppercaseChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
const lowercaseChars = 'abcdefghijklmnopqrstuvwxyz'
const numberChars = '0123456789'
const symbolChars = '!@#$%^&*()_+-=[]{}|;:,.<>?'

// Computed properties
const hasValidOptions = computed(() => {
  return includeUppercase.value || includeLowercase.value || includeNumbers.value || includeSymbols.value
})

const characterSet = computed(() => {
  let chars = ''
  if (includeUppercase.value) chars += uppercaseChars
  if (includeLowercase.value) chars += lowercaseChars
  if (includeNumbers.value) chars += numberChars
  if (includeSymbols.value) chars += symbolChars
  return chars
})

const passwordStrength = computed(() => {
  if (!generatedPassword.value) return 'None'
  
  const length = generatedPassword.value.length
  const hasUpper = /[A-Z]/.test(generatedPassword.value)
  const hasLower = /[a-z]/.test(generatedPassword.value)
  const hasNumber = /[0-9]/.test(generatedPassword.value)
  const hasSymbol = /[!@#$%^&*()_+\-=\[\]{}|;:,.<>?]/.test(generatedPassword.value)
  
  let score = 0
  if (length >= 8) score += 1
  if (length >= 12) score += 1
  if (length >= 16) score += 1
  if (hasUpper) score += 1
  if (hasLower) score += 1
  if (hasNumber) score += 1
  if (hasSymbol) score += 1
  
  if (score <= 3) return 'Weak'
  if (score <= 5) return 'Medium'
  if (score <= 6) return 'Strong'
  return 'Very Strong'
})

const strengthColor = computed(() => {
  switch (passwordStrength.value) {
    case 'Weak': return 'text-red-500'
    case 'Medium': return 'text-yellow-500'
    case 'Strong': return 'text-blue-500'
    case 'Very Strong': return 'text-green-500'
    default: return 'text-gray-500'
  }
})

const strengthPercentage = computed(() => {
  switch (passwordStrength.value) {
    case 'Weak': return 25
    case 'Medium': return 50
    case 'Strong': return 75
    case 'Very Strong': return 100
    default: return 0
  }
})

// Password validation function (similar to the shell script)
const isPasswordValid = (password: string): boolean => {
  if (password.length < 8) return false
  
  const hasUpper = includeUppercase.value ? /[A-Z]/.test(password) : true
  const hasLower = includeLowercase.value ? /[a-z]/.test(password) : true
  const hasNumber = includeNumbers.value ? /[0-9]/.test(password) : true
  const hasSymbol = includeSymbols.value ? /[!@#$%^&*()_+\-=\[\]{}|;:,.<>?]/.test(password) : true
  
  return hasUpper && hasLower && hasNumber && hasSymbol
}

// Generate password function
const generatePassword = () => {
  if (!hasValidOptions.value) return
  
  let password = ''
  let attempts = 0
  const maxAttempts = 100
  
  // Keep generating until we get a valid password (like the shell script)
  do {
    password = ''
    for (let i = 0; i < passwordLength.value; i++) {
      const randomIndex = Math.floor(Math.random() * characterSet.value.length)
      password += characterSet.value[randomIndex]
    }
    attempts++
  } while (!isPasswordValid(password) && attempts < maxAttempts)
  
  generatedPassword.value = password
  copied.value = false
}

// Copy to clipboard function
const copyToClipboard = async () => {
  if (!generatedPassword.value) return
  
  try {
    await navigator.clipboard.writeText(generatedPassword.value)
    copied.value = true
    setTimeout(() => {
      copied.value = false
    }, 2000)
  } catch (err) {
    console.error('Failed to copy password:', err)
    // Fallback for older browsers
    const textArea = document.createElement('textarea')
    textArea.value = generatedPassword.value
    document.body.appendChild(textArea)
    textArea.select()
    document.execCommand('copy')
    document.body.removeChild(textArea)
    copied.value = true
    setTimeout(() => {
      copied.value = false
    }, 2000)
  }
}

// Generate initial password
generatePassword()

// Watch for changes in options and regenerate if needed
watch([passwordLength, includeUppercase, includeLowercase, includeNumbers, includeSymbols], () => {
  if (generatedPassword.value && hasValidOptions.value) {
    generatePassword()
  }
})
</script>