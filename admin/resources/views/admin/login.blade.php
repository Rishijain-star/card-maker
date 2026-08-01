<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login — {{ $appName }}</title>
    <link rel="icon" href="{{ asset('assets/id-shaydi-logo.png') }}">
    <link rel="stylesheet" href="{{ asset('css/admin.css') }}">
</head>
<body class="login-page">
    <div class="login-card">
        <div class="login-brand">
            <img src="{{ asset('assets/id-shaydi-logo.png') }}" alt="ID-Shaydi">
            <h1>ID-Shaydi</h1>
            <p>Admin Panel Login</p>
        </div>

        @if ($errors->has('login'))
            <div class="login-error">{{ $errors->first('login') }}</div>
        @endif

        <form method="POST" action="{{ route('admin.login.submit') }}" class="login-form">
            @csrf
            <div class="field">
                <label for="username">Username</label>
                <input
                    id="username"
                    type="text"
                    name="username"
                    value="{{ old('username') }}"
                    placeholder="Enter username"
                    autocomplete="username"
                    required
                    autofocus
                >
            </div>
            <div class="field">
                <label for="password">Password</label>
                <input
                    id="password"
                    type="password"
                    name="password"
                    placeholder="Enter password"
                    autocomplete="current-password"
                    required
                >
            </div>
            <button type="submit" class="btn-login">Sign In</button>
        </form>
    </div>
</body>
</html>
