<a id="top"></a>

# SCATest — Browser Extension Lab

Uma base prática para começar extensões modernas sem bagunça.

Não é framework novo.
Não é revolução.
É só uma fundação organizada para você não perder tempo com setup repetitivo.

---

## Navegação

* [🇧🇷 Português (BR)](#pt-br)

  * [O que é](#pt-o-que-e)
  * [O que resolve](#pt-o-que-resolve)
  * [Estrutura](#pt-estrutura)
  * [Como rodar](#pt-como-rodar)
  * [Recriar do zero](#pt-recriar)
* [🇺🇸 English](#en)
  * [Quick start](#en-quick-start)

---

<a id="pt-br"></a>

# 🇧🇷 Português (BR)

Esse repositório é um laboratório simples para construir extensões com estrutura limpa desde o início.

A ideia aqui foi reduzir fricção:

* Setup previsível
* Organização clara
* UI já padronizada
* Base fácil de evoluir

Sem ritual manual toda vez que começar um projeto novo.

---

<a id="pt-o-que-e"></a>

## O que é

Uma extensão construída com:

* WXT (Manifest V3)
* React
* shadcn/ui
* Script de scaffold não interativo (com retry e limpeza automática em caso de erro)

É um ponto de partida sólido. Nada além disso — e isso já resolve bastante coisa.

---

<a id="pt-o-que-resolve"></a>

## O que resolve

* Estrutura organizada de entrypoints (`popup`, `options`, `custom`)
* UI componentizada desde o começo
* Projeto pronto para crescer sem virar caos
* Script que recria a base do zero sem lembrar 15 passos

A meta é padronizar o começo para focar na lógica depois.

---

<a id="pt-estrutura"></a>

## Estrutura

* `browser-extension-wxt-shadcn/` — projeto principal
* `scripts/scaffold-wxt-shadcn.ps1` — bootstrap automatizado

Direto ao ponto.

---

<a id="pt-como-rodar"></a>

## Como rodar

```powershell
cd browser-extension-wxt-shadcn
npm install
npm run dev
```

Build:

```powershell
npm run build
```

---

<a id="pt-recriar"></a>

## Recriar a base do zero

A partir da pasta onde você quer gerar o projeto:

```powershell
.\browser-extension-wxt-shadcn\scripts\scaffold-wxt-shadcn.ps1
```

Ou passando parâmetros:

```powershell
.\browser-extension-wxt-shadcn\scripts\scaffold-wxt-shadcn.ps1 -WorkspaceRoot "c:\destino" -ProjectName "minha-extensao"
```

Se falhar, limpa.
Se funcionar, já sai estruturado.
Sem sobra no diretório.

---

<a id="en"></a>

# 🇺🇸 English

This repository is a practical starting point for modern browser extensions.

Nothing fancy.
Just a clean, reusable baseline to avoid repetitive setup work.

Included:

* WXT (Manifest V3)
* React + shadcn/ui
* Organized entrypoints (`popup`, `options`, `custom`)
* A fully non-interactive scaffold script with retry and cleanup

It’s simply a structured foundation you can build on without fighting your own setup.

---

<a id="en-quick-start"></a>

## Quick start

```powershell
cd browser-extension-wxt-shadcn
npm install
npm run dev
```

Build:

```powershell
npm run build
```
