<template>
  <view class="pg-textarea">
    <view
      class="fuck-textarea-edit-content"
      :class="{ hidden: EditMode, border: border }"
      :style="{ height: height }"
      @click.stop="TapView"
    >
      <view v-if="Content === ''" class="fuck-textarea-edit-placeholder">{{ placeholder }}</view>
      {{ Content }}
    </view>
    <textarea
      class="fuck-textarea-edit-content"
      :class="[{ hidden: !EditMode }, { border: border }, placeholderClass]"
      :style="{ height: height }"
      :auto-height="autoHeight"
      :value="editValue"
      :focus="focus"
      :maxlength="maxlength"
      @blur="EditBlur"
      @input="handleInput"
    />
    <text v-if="showCount" class="fault-tip">{{ faultNumber }}</text>
  </view>
</template>

<script>
export default {
  name: 'PgTextarea',
  props: {
    value: {
      type: String,
      default: ''
    },
    placeholder: {
      type: String,
      default: ''
    },
    maxlength: {
      type: Number,
      default: 100
    },
    placeholderClass: {
      type: String,
      default: 'fuck-textarea-edit-placeholder'
    },
    height: {
      type: String,
      default: 'auto'
    },
    autoHeight: {
      type: Boolean,
      default: false
    },
    showCount: {
      type: Boolean,
      default: false
    },
    border: {
      type: Boolean,
      default: true
    }
  },
  data() {
    return {
      Content: '',
      EditMode: false,
      editValue: '',
      focus: ''
    }
  },
  computed: {
    faultNumber() {
      return this.Content.length + '/' + 100
    }
  },
  watch: {
    value(v) {
      this.Content = v
    }
  },
  mounted() {
    this.Content = this.value
  },
  methods: {
    TapView() {
      this.EditMode = true
      setTimeout(() => {
        this.editValue = this.value
        this.focus = true
      }, 100)
    },
    EditBlur() {
      this.EditMode = false
      this.focus = false
    },
    handleInput(e) {
      this.$emit('input', e)
    }
  }
}
</script>

<style lang="scss" scoped>
.pg-textarea {
  position: relative;
}
.hidden {
  display: none;
}

.fuck-textarea-edit-content {
  width: 100%;
  min-height: 42rpx;
  line-height: 42rpx;
  color: #333333;
  font-size: 32rpx;
  &.border {
    padding: 20rpx;
    box-sizing: border-box;
    position: relative;
    &::after {
      content: '';
      border-radius: 12rpx;
      @include retina-one-px-border(all);
    }
  }
}

.fuck-textarea-edit-placeholder {
  color: #999999;
}
.fault-tip {
  position: absolute;
  bottom: 24rpx;
  right: 24rpx;
  color: #999999;
}
</style>
