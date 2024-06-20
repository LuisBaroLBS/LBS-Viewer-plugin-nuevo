# lbs-viewer

Lbs book viewer

## Install

```bash
npm install lbs-viewer
npx cap sync
```

## API

<docgen-index>

* [`echo(...)`](#echo)
* [`openBook(...)`](#openbook)
* [`show(...)`](#show)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### echo(...)

```typescript
echo(options: { value: string; }) => Promise<{ value: string; }>
```

| Param         | Type                            |
| ------------- | ------------------------------- |
| **`options`** | <code>{ value: string; }</code> |

**Returns:** <code>Promise&lt;{ value: string; }&gt;</code>

--------------------


### openBook(...)

```typescript
openBook(options: { token: string; libroId: number; directory: string; }) => Promise<{ token: string; libroId: number; directory: string; }>
```

| Param         | Type                                                                |
| ------------- | ------------------------------------------------------------------- |
| **`options`** | <code>{ token: string; libroId: number; directory: string; }</code> |

**Returns:** <code>Promise&lt;{ token: string; libroId: number; directory: string; }&gt;</code>

--------------------


### show(...)

```typescript
show(options: { message: string; }) => Promise<{ message: string; }>
```

| Param         | Type                              |
| ------------- | --------------------------------- |
| **`options`** | <code>{ message: string; }</code> |

**Returns:** <code>Promise&lt;{ message: string; }&gt;</code>

--------------------

</docgen-api>
