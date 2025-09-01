<template>
  <div class="max-w-4xl mx-auto">
    <!-- Header (restored simpler title) -->
    <div class="text-center mb-10 relative">
      <h1 class="text-4xl md:text-5xl font-bold tracking-tight mb-4 text-white">
        Password<span class="text-primary-500">GEN</span>
      </h1>
      <p class="text-gray-400 max-w-2xl mx-auto text-lg">
        Generate secure passwords with customizable options.
      </p>
      <div class="pointer-events-none absolute -inset-x-10 -bottom-6 h-20 bg-[radial-gradient(circle_at_center,rgba(234,179,8,0.12),transparent_70%)] blur-xl"></div>
    </div>

    <!-- Main Card -->
  <div class="card p-8 md:p-10 space-y-12 overflow-hidden relative">
      <!-- Generated Password Display -->
      <div class="space-y-5 relative">
        <label class="block text-sm font-medium text-gray-300">
          Generated Password
        </label>
        <div class="relative group">
          <input
            :value="generatedPassword"
            readonly
            class="w-full bg-gradient-to-br from-dark-800 to-dark-900/90 border border-dark-600 rounded-2xl px-6 py-6 text-2xl md:text-3xl font-mono tracking-wide text-white focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent pr-28 shadow-inner"
            :placeholder="generatedPassword || 'Click generate to create a password'"
          />
          <button
            @click="copyToClipboard"
            :disabled="!generatedPassword"
            class="absolute right-3 top-1/2 -translate-y-1/2 p-3 rounded-xl transition-all duration-200 bg-dark-700/70 border border-dark-600 backdrop-blur hover:border-primary-500"
            :class="[
              generatedPassword 
                ? 'text-primary-500 hover:bg-dark-700 hover:text-primary-400' 
                : 'text-gray-600 cursor-not-allowed'
            ]"
            title="Copy to clipboard"
          >
            <svg v-if="!copied" class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z"></path>
            </svg>
            <svg v-else class="w-6 h-6 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
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
      <div class="pt-2">
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
        <div class="flex flex-wrap gap-2 mt-4 text-xs text-gray-500">
          <span>Shortcuts:</span>
          <kbd class="px-2 py-1 rounded bg-dark-800 border border-dark-600">R</kbd> regenerate
          <kbd class="px-2 py-1 rounded bg-dark-800 border border-dark-600">C</kbd> copy
          <kbd class="px-2 py-1 rounded bg-dark-800 border border-dark-600">H</kbd> history
        </div>
      </div>

      <!-- Password Strength Indicator -->
  <div v-if="generatedPassword" class="space-y-8">
        <div class="flex justify-between items-center">
          <span class="text-sm text-gray-400">Password Strength</span>
          <span :class="strengthColor" class="text-sm font-medium">
            {{ passwordStrength }}
          </span>
        </div>
        <div class="flex gap-2">
          <div v-for="n in 4" :key="n" class="flex-1 h-3 rounded-full overflow-hidden bg-dark-700 relative">
            <div class="absolute inset-0 transition-all duration-500" :class="segmentFillClass(n)"></div>
          </div>
        </div>
        <!-- Entropy -->
  <div class="flex flex-wrap items-center gap-4 text-xs text-gray-400">
          <div><span class="text-gray-500">Entropy:</span> <span class="text-gray-300 font-mono">{{ entropyBits.toFixed(1) }} bits</span></div>
          <div><span class="text-gray-500">Est. crack time:</span> <span class="text-gray-300">{{ crackTime }}</span></div>
          <button class="btn-secondary py-1 px-3 text-xs" @click="showInfo=!showInfo">{{ showInfo? 'Hide':'Why?' }}</button>
        </div>
        <transition name="fade-slide">
          <div v-if="showInfo" class="text-xs leading-relaxed bg-dark-800/60 border border-dark-600 rounded-lg p-4">
            Entropy estimates randomness. Higher bits exponentially increase resistance to brute force. Formula: log2(characterSetSize^length).
          </div>
        </transition>
        <!-- Policy Checklist -->
        <ul class="grid grid-cols-2 gap-2 text-xs text-gray-400">
          <li v-for="c in checklist" :key="c.label" class="flex items-center gap-1" :class="c.ok ? 'text-green-400':'text-gray-500'">
            <span>{{ c.ok ? '✓':'•' }}</span> {{ c.label }}
          </li>
        </ul>
        <!-- Compact History (collapsible) -->
        <div v-if="history.length" class="pt-2">
          <button @click="historyOpen = !historyOpen" class="text-xs text-primary-500 hover:text-primary-400 font-medium flex items-center gap-1">
            <span>{{ historyOpen ? 'Hide' : 'Show' }} History ({{ history.length }})</span>
            <span>{{ historyOpen ? '▾' : '▸' }}</span>
          </button>
          <transition name="fade-slide">
            <div v-if="historyOpen" class="mt-3 flex gap-2 overflow-x-auto pb-1 scrollbar-thin">
              <div v-for="item in history" :key="item.id" class="flex items-center gap-1 px-3 py-2 rounded-full bg-dark-800/70 border border-dark-700 hover:border-primary-500/60 text-[11px] whitespace-nowrap group relative">
                <code class="font-mono tracking-tight" :title="item.value">{{ item.revealed ? item.value : mask(item.value) }}</code>
                <button class="text-primary-500 hover:text-primary-400" @click="reUse(item.value)" title="Reuse">↺</button>
                <button class="text-gray-400 hover:text-green-400" @click="reveal(item)" title="Toggle mask">👁</button>
              </div>
            </div>
          </transition>
        </div>
      </div>
    </div>

    <!-- Footer -->
    <div class="text-center mt-8 text-gray-500 text-sm space-y-2">
      <p>🔒 All passwords are generated locally in your browser for maximum security</p>
      <p>
        Made with ❤️ by 
        <a 
          href="https://0xpacman.com" 
          target="_blank" 
          rel="noopener noreferrer"
          class="text-primary-500 hover:text-primary-400 transition-colors duration-200 font-medium"
        >
          0xPacman
        </a>
      </p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onBeforeUnmount } from 'vue'

// Reactive state
const generatedPassword = ref('')
const passwordLength = ref(16)
const includeUppercase = ref(true)
const includeLowercase = ref(true)
const includeNumbers = ref(true)
const includeSymbols = ref(true)
const copied = ref(false)
const history = ref<{id:number; value:string; revealed?:boolean}[]>([])
// history displayed in bottom section only
const historyOpen = ref(false)
const maxHistory = 5
const entropyBits = computed(() => {
  if (!generatedPassword.value) return 0
  const size = characterSet.value.length
  if (!size) return 0
  return generatedPassword.value.length * Math.log2(size)
})
const crackTime = computed(() => {
  // assume 1e12 guesses/sec modern attacker
  const guessesPerSec = 1e12
  const seconds = Math.pow(2, entropyBits.value) / guessesPerSec
  if (seconds < 60) return seconds.toFixed(2)+ 's'
  const minutes = seconds/60
  if (minutes < 60) return minutes.toFixed(1)+'m'
  const hours = minutes/60
  if (hours < 24) return hours.toFixed(1)+'h'
  const days = hours/24
  if (days < 365) return days.toFixed(1)+'d'
  const years = days/365
  if (years < 1000) return years.toFixed(1)+'y'
  return (years/1000).toFixed(2)+'k years'
})
const showInfo = ref(false)
const checklist = computed(() => [
  { label: '≥ 12 chars', ok: generatedPassword.value.length >= 12 },
  { label: 'Uppercase', ok: /[A-Z]/.test(generatedPassword.value) },
  { label: 'Lowercase', ok: /[a-z]/.test(generatedPassword.value) },
  { label: 'Number', ok: /[0-9]/.test(generatedPassword.value) },
  { label: 'Symbol', ok: /[!@#$%^&*()_+\-=\[\]{}|;:,.<>?]/.test(generatedPassword.value) },
  { label: 'Unique mix', ok: new Set(generatedPassword.value).size > generatedPassword.value.length * 0.6 }
])

// History helpers
const pushHistory = (pwd:string) => {
  if (!pwd) return
  history.value.unshift({ id: Date.now()+Math.random(), value: pwd })
  if (history.value.length > maxHistory) history.value.pop()
}
const mask = (pwd:string) => pwd.slice(0,4) + '••••' + pwd.slice(-2)
const reveal = (item:{revealed?:boolean}) => { item.revealed = !item.revealed }
const reUse = (pwd:string) => { generatedPassword.value = pwd }

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
  pushHistory(password)
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
// Removed auto-regeneration on option change to keep history stable

// Keyboard shortcuts
const keyHandler = (e:KeyboardEvent) => {
  if (e.target instanceof HTMLInputElement || e.target instanceof HTMLTextAreaElement) return
  if (e.key==='r' || e.key==='R') { generatePassword(); e.preventDefault() }
  if (e.key==='c' || e.key==='C') { copyToClipboard(); e.preventDefault() }
  if (e.key==='h' || e.key==='H') { historyOpen.value = !historyOpen.value; e.preventDefault() }
}
onMounted(() => {
  window.addEventListener('keydown', keyHandler)
  // ensure accent defaults (yellow) stays set if variables exist
  document.documentElement.style.setProperty('--accent', '#eab308')
  document.documentElement.style.setProperty('--accent-rgb', '234 179 8')
})
onBeforeUnmount(()=> window.removeEventListener('keydown', keyHandler))

// Segmented strength bar helper
const segmentFillClass = (n:number) => {
  const pct = strengthPercentage.value
  const segments = [25,50,75,100]
  const active = pct >= segments[n-1]
  if (!active) return ''
  if (pct <= 25) return 'bg-red-500'
  if (pct <= 50) return 'bg-yellow-500'
  if (pct <= 75) return 'bg-blue-500'
  return 'bg-green-500'
}
</script>